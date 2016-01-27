module PublicActivitiesHelper

  def user_alias owner
    owner.try(:username) || t('public_activity.someone')
  end

  def link_to_trackable(object, object_type)
    if object
      link_to object.name, object
    else
      t('public_activity.deleted', type: object_type)
    end
  end
end
