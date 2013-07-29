class ShopConfig < Settingslogic
  source "#{Rails.root}/config/shop_config.yml"
  namespace Rails.env
end