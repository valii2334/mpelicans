if defined?(CypressOnRails)
  require 'sidekiq/testing'
  Sidekiq::Testing.fake!
  Sidekiq::Testing.inline!

  CypressOnRails.configure do |c|
    c.cypress_folder = File.expand_path("#{__dir__}/../../cypress")
    # WARNING!! CypressOnRails can execute arbitrary ruby code
    # please use with extra caution if enabling on hosted servers or starting your local server on 0.0.0.0
    c.use_middleware = !Rails.env.production?
    #  c.use_vcr_middleware = !Rails.env.production?
    c.logger = Rails.logger
  end
end
