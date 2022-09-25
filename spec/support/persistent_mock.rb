RSpec.configure do |config|
  config.around(:example, :persist) do |example|
    FileUtils.mv(ENV.fetch("PERSISTENT_PATH"), ENV.fetch("PERSISTENT_PATH") + ".original")
    FileUtils.mkdir(ENV.fetch("PERSISTENT_PATH"))

    example.run
  ensure
    FileUtils.rm_rf(ENV.fetch("PERSISTENT_PATH"))
    FileUtils.mv(ENV.fetch("PERSISTENT_PATH") + ".original", ENV.fetch("PERSISTENT_PATH"))
  end
end
