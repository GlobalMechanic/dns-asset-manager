class SignedUrlController < ApplicationController
  def index
    render json: {
      policy: s3_upload_policy_document,
      signature: s3_upload_signature,
      key: "uploads/#{SecureRandom.uuid}/asset/#{params[:type]}/#{params[:id]}/#{params[:version]}_#{sanitize(params[:file])}",
      success_action_redirect: "/",
    }
  end

  private

  def s3_upload_policy_document
    Base64.encode64(
      {
        expiration: 30.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
        conditions: [
          { bucket: ENV['S3_BUCKET_NAME'] },
          { acl: 'public-read' },
          ["starts-with", "$key", "uploads/"],
          { success_action_status: '201' }
        ]
      }.to_json
    ).gsub(/\n|\r/, '')
  end

  def s3_upload_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        ENV['S3_SECRET'],
        s3_upload_policy_document
      )
    ).gsub(/\n/, '')
  end

  # From CarrierWave::SanitizedFile.
  def sanitize(name)
    name = name.gsub("\\", "/") # work-around for IE
    name = File.basename(name)
    name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/,"_")
    name = "_#{name}" if name =~ /\A\.+\z/
    name = "unnamed" if name.size == 0
    return name.mb_chars.to_s
  end
end
