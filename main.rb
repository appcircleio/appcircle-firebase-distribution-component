# frozen_string_literal: true

require 'English'
require 'os'

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
  run_command("mkdir -p #{path}")
  run_command("curl -L https://firebase.tools/bin/#{os}/#{version} -o #{path}/firebase")
  run_command("chmod +rx #{path}/firebase")
end

app_path = get_env_variable('AC_FIREBASE_APP_PATH')
raise 'Build path is empty' if app_path.nil?

app_id = get_env_variable('AC_FIREBASE_APP_ID')

raise 'App id is empty' if app_id.nil?

token = get_env_variable('AC_FIREBASE_TOKEN')
raise 'Firebase token is empty' if token.nil?

firebase_path = '$HOME/firebasetools'
install_firebase(firebase_path)

release_notes = get_env_variable('AC_FIREBASE_RELEASE_NOTES')
release_notes_path = get_env_variable('AC_FIREBASE_RELEASE_NOTES_PATH')

groups = get_env_variable('AC_FIREBASE_GROUPS')
extra_parameters = get_env_variable('AC_FIREBASE_EXTRA_PARAMETERS')

cmd = "#{firebase_path}/firebase appdistribution:distribute \"#{app_path}\" --app \"#{app_id}\" --token \"#{token}\""
cmd += " --groups \"#{groups}\"" unless groups.nil?
if release_notes.nil?
  cmd += " --release-notes-file \"#{release_notes_path}\"" unless release_notes_path.nil?
else
  cmd += " --release-notes \"#{release_notes}\""
end

cmd += " #{extra_parameters}" unless extra_parameters.nil?

result = run_command(cmd)
puts result
