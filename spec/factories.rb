FactoryGirl.define do
	factory :user do
	name "New User"
	email "new.user@example.com"
	password "foobar"
	password_confirmation "foobar"
	end
end