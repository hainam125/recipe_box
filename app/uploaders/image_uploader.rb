class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  #process resize_to_fill: [300, 300]
  # Create different versions of your uploaded files:
  version :thumb do
    #process esize_to_fill: [300, 300]
	process thumb: "224 300"
  end
  
  def thumb(dimention)
    w, h = dimention.split().map(&:to_i)
	manipulate! do |img|
	  ratio = img.width.to_f / img.height
	  if ratio < w.to_f/h #long height
	    resize = "#{w}x"
		width = w
		height = w / ratio
		off_height = height-h
		off_width = 0
	  elsif ratio > w.to_f/h #long width
	    resize = "x#{h}"
		height = h
		width = h * ratio
		off_height = 0
		off_width = width-w
	  else
	    resize = "#{w}x#{h}"
		width = w
		height = h
		off_width = 0
		off_height = 0
	  end
	  img.resize(resize)
	  img.crop "#{width}x#{height}+#{off_width}+#{off_height}!"
	end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
