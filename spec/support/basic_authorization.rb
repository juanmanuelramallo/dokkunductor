module BasicAuthorization
  def basic_authorization_header
    {
      HTTP_AUTHORIZATION:
        ActionController::HttpAuthentication::Basic.encode_credentials(
          ENV.fetch('HTTP_BASIC_AUTH_NAME'),
          ENV.fetch('HTTP_BASIC_AUTH_PASSWORD')
        )
    }
  end
end
