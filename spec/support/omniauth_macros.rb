# in spec/support/omniauth_macros.rb
module OmniauthMacros
  def mock_auth_hash
  # The mock_auth configuration allows you to set per-provider (or default)
  # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:facebook] = {
    	'provider' => 'facebook',
    	'uid' => '123545',
    	'user_info' => {
    		'name' => 'mockuser',
    		'first_name' => 'first',
    		'last_name' => 'last'
    		},
    	'credentials' => {
    	'token' => '123456',
    	'secret' => '123456'
    	}
    }
  end
end