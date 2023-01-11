# frozen_string_literal: true

require 'English'
require 'os'
require 'pathname'
require 'fileutils'

def get_env_variable(key)
  ENV[key].nil? || ENV[key] == '' ? nil : ENV[key]
end

def run_command(cmd)
  puts "@@[command] #{cmd}"
  output = `#{cmd}`
  raise "Command failed. Check logs for details \n\n #{output}" unless $CHILD_STATUS.success?

  output
end

def install_firebase(path)
  version = get_env_variable('AC_FIREBASE_VERSION').nil? ? 'latest' : ENV['AC_FIREBASE_VERSION']
  os = OS.mac? ? 'macos' : 'linux'
  FileUtils.mkdir_p(path) unless File.directory?(path)
  run_command("curl -L https://firebase.tools/bin/#{os}/#{version} -o #{path}/firebase")
  run_command("chmod +rx #{path}/firebase")
end

app_path = get_env_variable('AC_FIREBASE_APP_PATH')
raise 'Build path is empty' if app_path.nil?

app_id = get_env_variable('AC_FIREBASE_APP_ID')

raise 'App id is empty' if app_id.nil?

token = get_env_variable('AC_FIREBASE_TOKEN')
service_account = get_env_variable('GOOGLE_APPLICATION_CREDENTIALS')

raise 'No token or service account provided.' if token.nil? && service_account.nil?

raise 'Either use token or service account, not both.' if !token.nil? && !service_account.nil?

ac_temp = get_env_variable('AC_TEMP_DIR') || abort('Missing AC_TEMP_DIR variable.')
firebase_path = File.join(ac_temp, 'firebasetools')

install_firebase(firebase_path)

release_notes = get_env_variable('AC_FIREBASE_RELEASE_NOTES')
release_notes_path = get_env_variable('AC_FIREBASE_RELEASE_NOTES_PATH')

groups = get_env_variable('AC_FIREBASE_GROUPS')
extra_parameters = get_env_variable('AC_FIREBASE_EXTRA_PARAMETERS')

cmd = "#{firebase_path}/firebase appdistribution:distribute \"#{app_path}\" --app \"#{app_id}\""
cmd += " --token \"#{token}\"" unless token.nil?
cmd += " --groups \"#{groups}\"" unless groups.nil?
if release_notes.nil?
  cmd += " --release-notes-file \"#{release_notes_path}\"" unless release_notes_path.nil?
else
  cmd += " --release-notes \"#{release_notes}\""
end

cmd += " #{extra_parameters}" unless extra_parameters.nil?

result = run_command(cmd)
puts result
