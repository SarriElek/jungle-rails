require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new
    @user.first_name = Faker::Name.first_name
    @user.last_name = Faker::Name.last_name
    @user.email = Faker::Internet.free_email
    @user.password = '12345678'
    @user.password_confirmation = '12345678'
  end

  describe 'Validations' do
    it 'should run all validations' do
      expect(@user.valid?).to be_truthy
    end
    it 'should validate presence of first name' do
      @user.first_name = nil
      @user.valid?
      expect(@user.errors[:first_name]).to include('can\'t be blank')
    end
    it 'should validate presence of last name' do
      @user.last_name = nil
      @user.valid?
      expect(@user.errors[:last_name]).to include('can\'t be blank')
    end
    it 'should validate presence of email' do
      @user.email = nil
      @user.valid?
      expect(@user.errors[:email]).to include('can\'t be blank')
    end
    it 'should validate the email to be unique (not case sensitive)' do
      @user.email = 'email@email.com'
      @user.save
      @user_second = User.new
      @user_second.first_name = Faker::Name.first_name
      @user_second.last_name = Faker::Name.last_name
      @user_second.email = 'EMAIL@email.com'
      @user_second.password = '12345678'
      @user_second.password_confirmation = '12345678'
      @user_second.valid?
      expect(@user_second.errors[:email]).to include('has already been taken')
    end
    it 'should validate presence of password' do
      @user.password = nil
      @user.valid?
      expect(@user.errors[:password]).to include('can\'t be blank')
    end
    it 'should validate presence of password_confirmation' do
      @user.password_confirmation = nil
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include('can\'t be blank')
    end
    it 'should validate that password and password_confirmation match' do
      @user.password = Faker::Internet.password
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include('doesn\'t match Password')
    end
    it 'should validate the minimum password length == 8 ' do
      @user.password = '1234'
      @user.valid?
      expect(@user.errors[:password]).to include('8 characters is the minimum allowed')
    end
  end

  describe '.authenticate_with_credentials' do
    before(:each) do
      @user.save
      @email = @user.email
      @password = '12345678'
    end
    it 'should authenticate with valid password' do
      expect(User.authenticate_with_credentials(@email, @password)).to eql(@user)
    end
    it 'should not authenticate with invalid password' do
      @password = '87654321'
      expect(User.authenticate_with_credentials(@email, @password)).to be_nil
    end
      context 'spaces before and/or after the email' do
        it 'should authenticate with spaces before and/or after the email' do
          @email += '   '
          expect(User.authenticate_with_credentials(@email, @password)).to eql(@user)
        end
      end
      context 'case errors typing the email' do
        it 'should authenticate with case errors in the email' do
          @email.upcase!
          expect(User.authenticate_with_credentials(@email, @password)).to eql(@user)
        end
      end
  end

end

