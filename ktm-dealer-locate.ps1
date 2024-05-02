# Define the URI
$uri_us = "https://www.ktm.com/en-us/find-a-dealer/_jcr_content/root/responsivegrid_1_col/dealersearch.dealers.json?latitude=37.09024&longitude=-95.712891&country=US&qualification="
$uri_ca = "https://www.ktm.com/en-us/find-a-dealer/_jcr_content/root/responsivegrid_1_col/dealersearch.dealers.json?latitude=37.09024&longitude=-95.712891&country=CA&qualification="
# Send a GET request to the URI and convert the JSON response to a PowerShell object
$response = Invoke-WebRequest -Uri $uri_us | ConvertFrom-Json

# Create a new XML document for the GPX file
$gpx = New-Object System.Xml.XmlDocument

# Create the root element
$gpxRoot = $gpx.CreateElement("gpx")
$gpxRoot.SetAttribute("version", "1.1")
$gpxRoot.SetAttribute("creator", "PowerShell")
$gpx.AppendChild($gpxRoot)

# Iterate over the dealers
foreach ($dealer in $response.data) {
    # Create a new waypoint element with the latitude and longitude attributes
    $wpt = $gpx.CreateElement("wpt")
    $wpt.SetAttribute("lat", $dealer.geoCodeLatitude)
    $wpt.SetAttribute("lon", $dealer.geoCodeLongitude)

    # Add a name child element to the waypoint element
    $name = $gpx.CreateElement("name")
    $name.InnerText = $dealer.name
    $wpt.AppendChild($name)

    # Add a description child element to the waypoint element
    $desc = $gpx.CreateElement("desc")
    $desc.InnerText = "Address: "+ $dealer.street +", "+ $dealer.town +", "+ $dealer.region +" "+ $dealer.postcode +"`n`n" + "Phone: "+ $dealer.phone +"`n`n" + "Services: " + $dealer.productOffer + "`n`n" + "Hours: " + "`n" + $dealer.openingHour
    $wpt.AppendChild($desc)

    # Add a url child element to the waypoint element
    $url = $gpx.CreateElement("url")
    $url.InnerText = $dealer.websiteUrl
    $wpt.AppendChild($url)

    # Append the waypoint element to the GPX document
    $gpxRoot.AppendChild($wpt)
}

# Save the GPX document to a file
$gpx.Save("dealers.gpx")