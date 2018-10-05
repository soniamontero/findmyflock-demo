class Identity < ApplicationRecord
  belongs_to :developer

  def self.find_for_oauth(auth)
    identity = Identity.where(:provider => auth.provider, :uid => auth.uid).first
    unless identity.nil?
      identity.developer
    else
      registered_developer = Developer.where(:email => auth.info.email).first
      unless registered_developer.nil?
        Identity.create!(
          provider: auth.provider,
          uid: auth.uid,
          developer_id: registered_developer.id
          )
        registered_developer
      else
        developer = Developer.create!(
          email: auth.info.email,
          password: SecureRandom.base64(50),
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          subscribed_to_newsletter: true,
        )
        developer_provider = Identity.create!(
          provider:auth.provider,
          uid:auth.uid,
          developer_id: developer.id
            )
        developer
      end
    end
  end
end


