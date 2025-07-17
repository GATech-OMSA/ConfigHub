cask "pdf-expert@2.5.22" do
  version "2.5.22,764"
  sha256 "58d1b1f4731c89c110aa1aef6833b24e0c865487e24a9a13a92d90a9f72f9c38"  # Verified as of July 2025

  url "https://downloads.pdfexpert.com/versions/#{version.after_comma}/PDFExpert.zip"
  name "PDF Expert"
  desc "PDF viewer, editor, and annotator (legacy v2)"
  homepage "https://pdfexpert.com"

  livecheck do
    skip "legacy version not updated"
  end

  auto_updates false
  conflicts_with cask: "pdf-expert"

  app "PDF Expert.app"

  zap trash: [
    "~/Library/Application Support/PDF Expert",
    "~/Library/Preferences/com.readdle.PDFExpert.plist",
    "~/Library/Preferences/com.readdle.PDFExpert.PDFViewer.plist",
    "~/Library/Containers/com.readdle.PDFExpert",
    "~/Library/Group Containers/*.com.readdle.PDFExpert",
  ]
end
