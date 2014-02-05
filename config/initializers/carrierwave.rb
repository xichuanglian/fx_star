CarrierWave.configure do |config|
  config.storage = :grid_fs
  config.grid_fs_access_url = '/uploads/grid'
  config.root = Rails.root.join('tmp')
  config.cache_dir = "uploads"
end
