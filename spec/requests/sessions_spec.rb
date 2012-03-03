require 'spec_helper'

describe "Authentication" do

  before do
    User.create provider: "password", email: "test@test.com", password: "foobar", password_confirmation: "foobar"
  end

  describe "Sign in" do

    before do
      visit "/auth/password"
      fill_in "sessions_email", with: "test@test.com"
    end

    describe "with valid credentials" do

      before do
        fill_in "sessions_password", with: "foobar"
        click_button "Sign in"
      end

      it "authenticates valid email and password" do
        page.should have_content("Signed in")
      end

      it "has signed in user info" do
        page.should have_content("Signed in as: test@test.com")
      end

    end

    describe "without valid credentials" do

      before do
        fill_in "sessions_password", with: "wrongpassword"
        click_button "Sign in"
      end

      it "fails authentication with invalid password" do
        page.should have_content("Authentication failed")
      end

      it "does not have signed in user info" do
        page.should_not have_content("Signed in as: test@test.com")
      end

    end
  end

  describe "Sign out" do

    before do
      User.create email: "test@test.com", password: "foobar", password_confirmation: "foobar"
      visit "/auth/password"
      fill_in "sessions_email", with: "test@test.com"
      fill_in "sessions_password", with: "foobar"
      click_button "Sign in"
      click_link "Sign out"
    end

    it "acknowledges signing out" do
      page.should have_content("Signed out")
    end

    it "does not have signed in user info" do
      page.should_not have_content("Signed in as: test@test.com")
    end

  end
end
