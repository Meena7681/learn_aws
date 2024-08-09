require 'aws-sdk-s3'      # AWS SDK for Ruby, used to interact with Amazon S3
require 'pry'             # Pry is an alternative to the standard IRB shell for Ruby
require 'securerandom'    # SecureRandom is a module to generate random numbers that are secure enough for cryptographic use

# Define the name of the S3 bucket from an environment variable.
bucket_name = ENV['BUCKET_NAME']

# Define the AWS region where the bucket will be created.
region = 'ap-south-1'

# Create an S3 client object to interact with the S3 service.
client = Aws::S3::Client.new

# Create a new S3 bucket with the specified name and region.
resp = client.create_bucket({
    bucket: bucket_name,                       # The name of the bucket to create.
    create_bucket_configuration: {
        location_constraint: region            # Specifies the AWS region where the bucket will be created.
    }
})

# binding.pry

# Generate a random number of files to create and upload (between 1 and 6).
number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"     # Output the number of files that will be created and uploaded.

# Iterate over the range of numbers (from 0 to number_of_files - 1).
number_of_files.times.each do |i|
    puts "i: #{i}"                             # Output the current index (file number).

    # Generate a filename using the current index.
    filename = "file_#{i}.txt"
    
    # Define the local path where the file will be temporarily stored.
    output_path = "/tmp/#{filename}"

    # Open the file at the specified path in write mode.
    File.open(output_path, "w") do |f|
        # Write a randomly generated UUID to the file.
        f.write(SecureRandom.uuid)
    end

    # Open the file in binary read mode and upload it to the S3 bucket.
    File.open(output_path, 'rb') do |f|
        client.put_object(
            bucket: bucket_name,               # The name of the S3 bucket where the file will be uploaded.
            key: filename,                     # The key (filename) under which to store the object in the S3 bucket.
            body: f                            # The contents of the file to upload.
        )
    end
end
