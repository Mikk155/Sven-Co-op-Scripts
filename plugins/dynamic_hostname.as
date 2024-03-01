#include '../mikk/shared'

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor( "Mikk" );
    g_Module.ScriptInfo.SetContactInfo( Mikk.GetContactInfo() );

    Mikk.Json.ReadJsonFile( "plugins/dynamic_hostname", pJson );
}

JSon pJson;

void MapActivate()
{
    string mapname = string( g_Engine.mapname ).ToLowercase();
    mapname.ToLowercase();

    dictionary g_Maps = pJson.getlabel( "MAPS" );

    const array<string> strMaps = g_Maps.getKeys();

    for( uint i = 0; i < strMaps.length(); i++ )
    {
        string key = strMaps[i];
        key.ToLowercase();

        if(
            ( key == mapname )
        ||
            ( key.EndsWith( "*", String::CaseInsensitive ) && mapname.StartsWith( key.SubString( 0, key.Length() -1 ) ) )
        ||
            ( key.StartsWith( "*", String::CaseInsensitive ) && mapname.EndsWith( key.SubString( 1, key.Length() ) ) )
        ){
            mapname = string( pJson.get( key + ":MAPS" ) );
            break;
        }
    }

    string antirush = pJson.get( "DISABLED:CONFIG" );

    array<string> strAntirush =
    {
        "trigger_once_mp",
        "trigger_multiple_mp",
        "antirush",
        "anti_rush"
    };

    for( uint i = 0; i < strAntirush.length(); i++ )
    {
        CBaseEntity@ pAntiRush = null;

        while( ( @pAntiRush = g_EntityFuncs.FindEntityByClassname( pAntiRush, strAntirush[i] ) ) !is null )
        {
            antirush = pJson.get( "ENABLED:CONFIG" );
            break;
        }
    }

    string m_iszHostName = pJson.get( "DYNAMIC_HOSTNAME:CONFIG" );
    m_iszHostName.Replace( "$hostname$", pJson.get( "HOSTNAME:CONFIG" ) );
    m_iszHostName.Replace( "$maps$", mapname );
    m_iszHostName.Replace( "$antirush$", antirush );
    m_iszHostName.Replace( "$survival$", pJson.get( ( g_SurvivalMode.MapSupportEnabled() ? "ENABLED" : "DISABLED" ) + ":CONFIG" ) );

    g_EngineFuncs.ServerCommand( "hostname \"" + m_iszHostName + "\"\n" );
    g_EngineFuncs.ServerExecute();
}