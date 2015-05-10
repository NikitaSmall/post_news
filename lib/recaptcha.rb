module Captcha
  class Recaptcha
    def self.verify(params)
      options = {
          body: {
              secret:   ENV['RECAPTCHA_PRIVATE_KEY'],
              response: params['g-recaptcha-response']#,
              #remoteip: params[:remoteip]
          }}
      HTTParty.post('https://www.google.com/recaptcha/api/siteverify', options)
      # answer = JSON.parse(json)

      # answer.success
    end
  end
end
