#include <sourcemod>
#include <sdktools>

#define PLUGIN_NAME    "DoD:S Snowfall"
#define PLUGIN_VERSION "1.0"

new Handle:enabled = INVALID_HANDLE

public Plugin:myinfo =
{
	name        = PLUGIN_NAME,
	author      = "Root",
	description = "Plugin enables snowfall effect on some maps",
	version     = PLUGIN_VERSION,
	url         = "http://dodsplugins.com/"
}

public OnMapStart()
{
	CreateConVar("dod_weather_version", PLUGIN_VERSION, PLUGIN_NAME, FCVAR_NOTIFY|FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED)
	enabled = CreateConVar("dod_snowfall_enable", "1", "Whether or not enable snowfall effect", FCVAR_PLUGIN, true, 0.0, true, 1.0)
}

public OnConfigsExecuted()
{
	if (GetConVarBool(enabled))
	{
		decl String:curmap[64], String:buffer[64], String:precipitation[64]

		GetCurrentMap(curmap, sizeof(curmap))
		Format(buffer, sizeof(buffer), "maps/%s.bsp", curmap)
		Format(precipitation, sizeof(precipitation), "%i", 3)

		new entity = -1
		if ((entity = CreateEntityByName("func_precipitation")) != -1)
		{
			decl Float:min[3], Float:max[3], Float:m_vecOrigin[3]

			DispatchKeyValue(entity, "model",      buffer)
			DispatchKeyValue(entity, "preciptype", precipitation)
			DispatchSpawn(entity)
			ActivateEntity(entity)

			GetEntPropVector(0, Prop_Data, "m_WorldMins", min)
			GetEntPropVector(0, Prop_Data, "m_WorldMaxs", max)

			SetEntPropVector(entity, Prop_Send, "m_vecMins", min)
			SetEntPropVector(entity, Prop_Send, "m_vecMaxs", max)

			m_vecOrigin[0] = (min[0] + max[0]) / 2
			m_vecOrigin[1] = (min[1] + max[1]) / 2
			m_vecOrigin[2] = (min[2] + max[2]) / 2

			TeleportEntity(entity, m_vecOrigin, NULL_VECTOR, NULL_VECTOR)
		}
	}
}