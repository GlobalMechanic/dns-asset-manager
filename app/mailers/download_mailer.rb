class DownloadMailer < ActionMailer::Base
  def download_ready(email, episode, upload_name)
    mail(
      from: "studio@globalmechanic.com",
      to: email,
      subject: "Your episode is ready for #{episode.number} #{episode.title}",
      body: "Click to download: https://asset-manager-testing.s3.amazonaws.com/#{upload_name}",
      content_type: "text/html",
    )
  end
end
