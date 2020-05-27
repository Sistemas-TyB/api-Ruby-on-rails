json.user do
    json.extract! @user, :id, :email#, :permission_level
end
json.message t('user.update', email: @user.email)