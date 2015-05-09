Recaptcha.configure do |config|
  config.public_key  = '6LcDlgYTAAAAAEgf_ED82Bv1sScP2iFXwkxYaAu3'
  config.private_key = '6LcDlgYTAAAAAOi8r2IzqmEwlYLt1GGiWxh9kuJ_'
  config.api_version = 'v2'

  Recaptcha.configuration.skip_verify_env.delete("test")

  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
  # Uncomment if you want to use the newer version of the API,
  # only works for versions >= 0.3.7:
  # config.api_version = 'v2'
end