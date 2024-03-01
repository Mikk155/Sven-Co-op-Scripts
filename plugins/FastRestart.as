#include '../mikk/shared'

void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor( "Mikk" );
    g_Module.ScriptInfo.SetContactInfo( Mikk.GetContactInfo() );
    Mikk.Hooks.RegisterHook( Hooks::Game::SurvivalEndRound, @SurvivalEndRound );
}

HookReturnCode SurvivalEndRound()
{
    try { g_EntityFuncs.CreateEntity( "player_loadsaved", {{'targetname','s'},{'loadtime','1'}}, true ).Use( null, null, USE_TOGGLE, 0 ); }
    catch { g_EngineFuncs.ChangeLevel( string( g_Engine.mapname ) ); }
    return HOOK_CONTINUE;
}