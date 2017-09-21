#include <sourcemod>
#include <sdktools>
 
#pragma newdecls required
#pragma semicolon 1

#define TAG_MESSAGE "[\x02VIP\x01]"

public Plugin myinfo =
{
    name = "VIP adder.",
    author = "B3none",
    description = "Temporarily give players VIP in the server.",
    version = "0.1.0",
    url = "https://forums.alliedmods.net/showthread.php?t=301305"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_addstatus", addStatus, ADMFLAG_GENERIC);
}

public Action addStatus(int client, int target)
{
	if (!IsValidClient(client) || !IsValidClient(target)) {
		return;
	}
	
	
	char clientName[64];
	char targetName[64];
	
	GetClientName(client, clientName, strlen(clientName));
	GetClientName(target, targetName, strlen(targetName));
	
	if (CheckCommandAccess(target, "sm_admin_check", ADMFLAG_RESERVATION)) {
		AddUserFlags(target, Admin_Reservation);
	}
	
	PrintToChatAll("%s %s granted VIP access to %s", TAG_MESSAGE, clientName, targetName);
}

stock bool IsValidClient(int client)
{
	return (client <= 0 || client > MAXPLAYERS+1 || !IsClientInGame(client));
}
