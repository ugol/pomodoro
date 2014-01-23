#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'fileutils'

$xpc_extension = ".xpc"
$service_name = "GNTPClientService"
$start_base_id = "com.company.application"
$start_id = $start_base_id + "." + $service_name
$start_package = $start_id + $xpc_extension
$new_package = $start_package
$entitlement_path = File.join("Contents", "Resources", $service_name + ".entitlements")


class PlistBuddy
  BIN = '/usr/libexec/PlistBuddy'

  def initialize(plist)
    @plist = plist
  end

  def [](prop)
    value = `#{BIN} -c 'Print :#{prop}' #{@plist} 2>/dev/null`
    $?.success? ? value.strip : nil
  end

  def []=(prop, val)
    if val.nil?
      `#{BIN} -c 'Delete :#{prop}' #{@plist} 2>/dev/null`
    else
      prev = self[prop]
      if prev.nil?
        `#{BIN} -c 'Add :#{prop} string #{val}' #{@plist} 2>/dev/null`
      else
        `#{BIN} -c 'Set :#{prop} #{val}' #{@plist} 2>/dev/null`
      end
    end

    val
  end
end


def rename(bundle_id)
  if File.exists?($start_package)
    puts("Creating " + $new_package + " from " + $start_package)

    #remove an existing copy, helpful for us because we could be building a new XPC to test
    FileUtils.rm_r($new_package) if File.exists?($new_package)

    #make our new XPC
    FileUtils.cp_r($start_package, $new_package)
    info_path = File.join($new_package, "Contents", "Info.plist")

    #fix the Info.plist
    plist = PlistBuddy.new(info_path)
    plist['CFBundleIdentifier'] = bundle_id
    plist['CFBundleExecutable'] = bundle_id
    plist['CFBundleName'] = bundle_id

    #Fix the executable
    exec_dir = File.join($new_package, "Contents", "MacOS")
    old_exec = File.join(exec_dir, $start_id)
    new_exec = File.join(exec_dir, bundle_id)
    File.rename(old_exec, new_exec)
  else
    puts("No bundle named " + $start_package + " found")
  end
end

def resign(identity)
  if File.exists?($new_package)
    puts("Resigning with identity " + identity)
    system("codesign", "-f", "-s", identity, "--entitlements", File.join($new_package, $entitlement_path), $new_package)

    #system("codesign", "-dvvvv", "--entitlements", ":-", $new_package)
    if system("codesign", "-v", $new_package)
      puts("Code resign valid")
    else
      puts("There was an error with the signature")
    end
  end
end

def main
  #where is the original XPC (it might be beside us, but let the argument tell us)
  #For us in an Extra or Dev tool this is $SRCROOT/../../build/$CONFIGURATION
  start_location = ARGV[0]
  #What app are we putting this in?
  # ex: $BUILT_PRODUCTS_DIR/$WRAPPER_NAME
  app_base = ARGV[1]
  #use $CODE_SIGNING_IDENTITY
  new_signing_identity = ARGV[2]

  contents_path = File.join(app_base, "Contents")
  info_path = File.join(contents_path, "Info.plist")

  #get the app's bundle id, this will be our base ID
  plist = PlistBuddy.new(info_path)
  bundle_id = plist['CFBundleIdentifier']

  xpc_id = bundle_id + "." + $service_name
  $new_package = xpc_id + $xpc_extension

  #keep things simpler in rename/resign and move to that directory
  #for us this is usefull, for developers, they may not need this
  cur_dir = Dir.getwd
  Dir.chdir(start_location)

  rename(xpc_id)
  resign(new_signing_identity)

  Dir.chdir(cur_dir)

  xpcs_dir = File.join(contents_path, "XPCServices")
  xpc_origin = File.join(start_location, $new_package)
  xpc_dest = File.join(xpcs_dir, $new_package)

  #make <app>/Contents/XPCServices if it doesn't exist
  Dir.mkdir(xpcs_dir) unless File.exists?(xpcs_dir)

  #remove an existing copy if it exists
  FileUtils.rm_r(xpc_dest) if File.exists?(xpc_dest)
  FileUtils.cp_r(xpc_origin, xpc_dest)
end

if __FILE__ == $0
  main
end
