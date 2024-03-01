#include '../mikk/shared'

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor( "Mikk" );
    g_Module.ScriptInfo.SetContactInfo( Mikk.GetContactInfo() );

    Mikk.Json.ReadJsonFile( "plugins/SurvivalRespawnAll", pJson );

    g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @ClientPutInServer );
    Mikk.Hooks.RegisterHook( Hooks::Game::SurvivalEndRound, @SurvivalEndRound );
}

JSon pJson;

void MapInit()
{
    if( pJson.getboolean( "INSTANT_ENABLE:CONFIG" ) && g_SurvivalMode.MapSupportEnabled() && g_SurvivalMode.GetStartOn() )
    {
        g_SurvivalMode.SetDelayBeforeStart( 0.0f );
        g_SurvivalMode.Activate( true );
    }
}

HookReturnCode ClientPutInServer( CBasePlayer@ pPlayer )
{
    if( pPlayer !is null )
    {
        if( !TrackPlayers.exists( Mikk.PlayerFuncs.GetSteamID( pPlayer ) ) )
        {
            g_Scheduler.SetTimeout( "SpawnPlayer", 4.5f, EHandle( pPlayer ) );
        }
    }
    return HOOK_CONTINUE;
}

void SpawnPlayer( EHandle hPlayer )
{
    if( hPlayer.IsValid() && g_SurvivalMode.IsActive() )
    {
        CBasePlayer@ pPlayer = cast<CBasePlayer>( hPlayer.GetEntity() );

        if( pPlayer !is null )
        {
            if( !pPlayer.IsAlive() )
            {
                Mikk.PlayerFuncs.RespawnPlayer( pPlayer );
            }
            Mikk.Language.Print( pPlayer, pJson, "SPAWNED" );
            TrackPlayers[ Mikk.PlayerFuncs.GetSteamID( pPlayer ) ] = "Spawned";
        }
    }
}

dictionary TrackPlayers;

HookReturnCode SurvivalEndRound()
{
    TrackPlayers.deleteAll();
    return HOOK_CONTINUE;
}