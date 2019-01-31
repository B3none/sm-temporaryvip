#include <sourcemod>
#include <sdktools>
 
#pragma newdecls required
#pragma semicolon 1

#define MESSAGE_PREFIX "[\x02VIP\x01]"
#define CODE_LENGTH 6

static const char vipCodes[][] =
{
	"adszxc",
	"moomoo",
};

static const char tokenCharacters[][] =
{
	"a", "b", "c", "d", "e", "f",
	"g", "h", "i", "j", "k", "l",
	"m", "n", "o", "p", "q", "r",
	"s", "t", "u", "v", "w", "x",
	"y", "z", "A", "B", "C", "D",
	"E", "F", "G", "H", "I", "J",
	"K", "L", "M", "N", "O", "P",
	"Q", "R", "S", "T", "U", "V",
	"W", "X", "Y", "Z", "0", "1",
	"2", "3", "4", "5", "6", "7",
	"8", "9"
};

bool isVIP[MAXPLAYERS + 1];

public Plugin myinfo =
{
    name = "Temporary VIP",
    author = "B3none",
    description = "Temporarily give players VIP in the server.",
    version = "0.1.2",
    url = "https://github.com/b3none"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_vip", CheckCode);
	
	RegAdminCmd("sm_addstatus", AddStatus, ADMFLAG_ROOT);
	RegAdminCmd("sm_generate", GenerateNewCode, ADMFLAG_ROOT);
}

public Action GenerateNewCode(int client, int args)
{
	char newCode[CODE_LENGTH];
	
	for(int i = 1; i <= CODE_LENGTH; i++)
	{
		Format(newCode, sizeof(newCode), "%s%s", newCode, tokenCharacters[GetRandomInt(0, sizeof(tokenCharacters) - 1)]);
	}
	
	// Add code to database
	
	PrintToChat(client, "%s The generated code is %s", MESSAGE_PREFIX, newCode);
	LogMessage("%s %N generated code \"%s\"", MESSAGE_PREFIX, client, newCode);
}

public Action CheckCode(int client, int args)
{
	char code[64];
	GetCmdArgString(code, sizeof(code));
	
	if(strlen(code) > CODE_LENGTH)
	{
		PrintToChat(client, "%s Invalid code.", MESSAGE_PREFIX);
		return;
	}
	
	for (int i = 0; i <= sizeof(vipCodes); i++) {
		if (StrEqual(code, vipCodes[i])) {
			AddStatus(0, client);
			
			// Remove used code from the database
			
			break;
		}
	}
	
	PrintToChat(client, "%s Invalid token.", MESSAGE_PREFIX);
}

public Action AddStatus(int client, int args)
{
	char targetSearch[64];
	GetCmdArgString(targetSearch, sizeof(targetSearch));

	int target = FindTarget(client, targetSearch);
	
	if ((!IsValidClient(client) && client != 0) || !IsValidClient(target))
	{
		return;
	}
	else if (CheckCommandAccess(target, "sm_admin_check", ADMFLAG_RESERVATION))
	{
		return;
	}
	
	AddUserFlags(target, Admin_Reservation);
	isVIP[target] = true;
	
	if (client == 0) 
	{
		PrintToChatAll("%s %N was granted temporary VIP access via a secret token", MESSAGE_PREFIX, target);
	} 
	else 
	{
		PrintToChatAll("%s %N granted temporary VIP access to %N", MESSAGE_PREFIX, client, target);
	}
}

public void OnRebuildAdminCache()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if (isVIP[i]) {
			AddUserFlags(i, Admin_Reservation);
		}
	}
}

public void OnClientDisconnect(int client)
{
	isVIP[client] = false;
}

stock bool IsValidClient(int client)
{
    return client > 0 && client <= MaxClients && IsClientInGame(client) && IsClientConnected(client) && IsClientAuthorized(client) && !IsFakeClient(client);
}
