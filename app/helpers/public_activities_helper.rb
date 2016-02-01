module PublicActivitiesHelper

  def user_alias owner
    owner.try(:username) || t('public_activity.someone')
  end

  def link_to_trackable(object, name)
    if object
      link_to object.name, object
    elsif name.present?
      name
    else
      t('public_activity.deleted')
    end
  end
end
