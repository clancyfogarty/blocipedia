module WikisHelper
  def private_wiki_access?
    current_user.admin? || current_user.premium?
  end
end
