require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

  context "unaunthenticated users" do
    it "GET show returns http unaunthenticated" do
      get :show, id: my_post.id
      expect(response).to have_http_status(401)
    end
  end

  context "authenticated and unauthorized users" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it "GET show returns http forbidden" do
      get :show, id: my_post.id
      expect(response).to have_http_status(403)
    end
  end

  context "authenticated and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    describe "GET show" do
      before { get :show, id: my_post.id }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "returns my_post serialized" do
        expect(response.body).to eq(my_post.to_json)
      end
    end
  end
end
