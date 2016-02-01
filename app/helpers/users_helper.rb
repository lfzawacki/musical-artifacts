module UsersHelper

  def auth_provider_name name
    name_map(name)
  end

  def auth_provider_icon name
    "fa fa-#{icon_map(name)}"
  end

  private
  def icon_map name
    {google_oauth2: 'google', linuxfr: 'linux'}[name] || name
  end

  def name_map name
    {google_oauth2: 'Google', linuxfr: 'LinuxFR'}[name] || name.capitalize
  end

end
