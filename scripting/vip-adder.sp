#include <sourcemod>
#include <sdktools>
 
#pragma newdecls required
#pragma semicolon 1

#define TAG_MESSAGE "[\x02VIP\x01]"

static const char vipCodes[][] =
{
	"adszxc",
	"moomoo",
}; 

public Plugin myinfo =
{
    name = "Give VIP",
    author = "B3none",
    description = "Temporarily give players VIP in the server.",
    version = "0.1.1",
    url = "https://forums.alliedmods.net/showthread.php?t=301305"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_vip", checkCode);
	RegAdminCmd("sm_addstatus", addStatus, ADMFLAG_GENERIC);
	RegAdminCmd("sm_generate", addStatus, ADMFLAG_GENERIC);
}

public Action generateNewCode()
{
	// Generate a new VIP code
}

public Action checkCode(int client, int args)
{
	char code[64];
	GetCmdArgString(code, sizeof(code));
	
	for (int i = 0; i <= sizeof(vipCodes); i++) {
		if (StrEqual(code, vipCodes[i])) {
			addStatus(0, client);
			break;
		}
	}
	
	PrintToChat(client, "%s Invalid token.", TAG_MESSAGE);
}

public Action addStatus(int client, int target)
{
	if ((!IsValidClient(client) && client != 0) || !IsValidClient(target)) {
		return;
	}
	
	
	char clientName[64];
	char targetName[64];
	
	GetClientName(client, clientName, sizeof(clientName));
	GetClientName(target, targetName, sizeof(targetName));
	
	if (CheckCommandAccess(target, "sm_admin_check", ADMFLAG_RESERVATION)) {
		AddUserFlags(target, Admin_Reservation);
	}
	
	if (client == 0) {
		PrintToChatAll("%s %s was granted VIP access via a secret token", TAG_MESSAGE, targetName);
	} else {
		PrintToChatAll("%s %s granted VIP access to %s", TAG_MESSAGE, clientName, targetName);
	}
}

stock bool IsValidClient(int client)
{
	return (client <= 0 || client > MAXPLAYERS+1 || !IsClientInGame(client));
}
