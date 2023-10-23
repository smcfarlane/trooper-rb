# frozen_string_literal: true

class Trooper
  hash_branch('users') do |r|
    r.is 'sign_in' do
      hx_render 'users/sign_in'
    end

    r.is 'sign_out' do
      r.delete do
      end
    end

    r.is 'register' do
      hx_render 'users/sign_up'
    end
  end
end
