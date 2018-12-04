




event AppShutdown()
{
	var hproj

	Close_All

	hproj = GetCurrentProj ()

	if (hproj != 0)
	{
		Close_Project		
	}
}


