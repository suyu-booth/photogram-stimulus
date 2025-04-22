require "rails_helper"

RSpec.describe FollowRequestsController, type: :controller do
  render_views

  describe "create" do
    it "responds to turbo_stream requests", points: 1 do
      sender = User.create(
        username: "sender",
        email: "sender@example.com",
        password: "password",
        avatar_image: File.open("#{Rails.root}/spec/support/test_image.jpeg")
      )

      recipient = User.create(
        username: "recipient",
        email: "recipient@example.com",
        password: "password",
        avatar_image: File.open("#{Rails.root}/spec/support/test_image.jpeg")
      )

      sign_in sender

      params = { follow_request: { recipient_id: recipient.id, status: "pending" } }

      post :create, params: params, as: :turbo_stream

      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(response.body).to have_tag("turbo-stream")
    end
  end

  describe "destroy" do
    it "responds to turbo_stream requests", points: 1 do
      sender = User.create(
        username: "sender",
        email: "sender@example.com",
        password: "password",
        avatar_image: File.open("#{Rails.root}/spec/support/test_image.jpeg")
      )

      recipient = User.create(
        username: "recipient",
        email: "recipient@example.com",
        password: "password",
        avatar_image: File.open("#{Rails.root}/spec/support/test_image.jpeg")
      )

      follow_request = FollowRequest.create(
        sender: sender,
        recipient: recipient,
        status: "pending"
      )

      sign_in sender

      delete :destroy, params: { id: follow_request.id }, as: :turbo_stream

      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(response.body).to have_tag("turbo-stream")
    end
  end
end
