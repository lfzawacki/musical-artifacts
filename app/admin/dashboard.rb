ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Artifacts" do
          ul do
            Artifact.order('created_at DESC').first(8).map do |art|
              li link_to(art.name, admin_artifact_path(art))
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Recent Tags" do
          ul do
            Searches.recent_tags(10).map do |tag|
              li link_to(tag.name, '#')
            end
          end
        end
      end

      column do
        panel "Most used Tags" do
          ul do
             Searches.tags('').order('taggings_count DESC').first(10).map do |tag|
              li link_to("#{tag.name} (#{tag.taggings_count})", '#')
            end
          end
        end
      end

    end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
