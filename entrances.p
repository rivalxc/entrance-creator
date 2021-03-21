
#include    a_samp
#include    a_ugmp
#include    zcmd
#include    sscanf2
#include    streamer

static entrance_export[220], exit_export[220], entrance_name[32], last_entrance;
CMD:createentrance(playerid, params[])
{
    entrance_name[0] = EOS;
    entrance_export[0] = EOS;
    exit_export[0] = EOS;

    if(!IsPlayerAdmin(playerid))                                    return SendClientMessage(playerid, 0xdd3c3cff, "You don't have sufficient permissions to use this!");
    if(GetPlayerInterior(playerid) > 0)                             return SendClientMessage(playerid, 0xdd3c3cff, "You cannot create entrance being inside building!");
    
    new entrance_mapicon;
    if(sscanf(params, "s[32]d", entrance_name, entrance_mapicon))   return SendClientMessage(playerid, 0xff8400ff, "Create entrance: /createentrance [entrance name] [map icon]");
    if(strlen(entrance_name) < 1 || strlen(entrance_name) > 32)     return SendClientMessage(playerid, 0xdd3c3cff, "Entrance name should be in range of 1 - 32 characters!");

    static Float:p_entrance[3], pname[21];
    GetPlayerName(playerid, pname, sizeof pname);
    GetPlayerPos(playerid, p_entrance[0], p_entrance[1], p_entrance[2]);
    
    format(entrance_export, sizeof entrance_export, "(%s) %s: Entrance->CreateDynamicPickup(19198, 6, %0.f, %0.f, %0.f, 0, 0);\r\n", pname, entrance_name, p_entrance[0], p_entrance[1], p_entrance[2]);
    format(entrance_export, sizeof entrance_export, "%s(%s) %s: Entrance->CreateDynamicMapIcon(%0.f, %0.f, %0.f, %d, -1, 0, 0);\r\n", entrance_export, pname, entrance_name, p_entrance[0], p_entrance[1], p_entrance[2], entrance_mapicon);
    
    SendClientMessage(playerid, 0xAFAFAFAF, "[ENTRANCES] {E0E0E0}Use SA-styled yellow arrow to enter interior!");
    SendClientMessage(playerid, 0xAFAFAFAF, "[ENTRANCES] {E0E0E0}If you are in interior you want to create entrance for type {40f753}/createexit");
    return 1;
}

CMD:createexit(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))                    return SendClientMessage(playerid, 0xdd3c3cff, "You don't have sufficient permissions to use this!");
    if(GetPlayerInterior(playerid) == 0)            return SendClientMessage(playerid, 0xdd3c3cff, "You cannot proceed creating entrance without being in interior!");
    if(!strlen(entrance_export))                    return SendClientMessage(playerid, 0xdd3c3cff, "You didn't created entrance, or some error occured while creating. Try again!");
    if(!strlen(entrance_name))                      return SendClientMessage(playerid, 0xdd3c3cff, "Your entrance doesn't have name assigned to it!");
    
    static Float:p_exit[3], pname[21];
    GetPlayerName(playerid, pname, sizeof pname);
    GetPlayerPos(playerid, p_exit[0], p_exit[1], p_exit[2]);
    format(exit_export, sizeof exit_export, "(%s) %s: Exit->CreateDynamicPickup(19198, 6, %0.f, %0.f, %0.f, 0, %d);\r\n", pname, entrance_name, p_exit[0], p_exit[1], p_exit[2], GetPlayerInterior(playerid));
    
    if(fexist("entrances/dntmv.cr"))
    {
        new file[32], File:ftw;
        format(file, sizeof file, "entrances/entrance_%02d.cr", last_entrance);
        
        ftw = fopen(file, io_append);
        fwrite(ftw, entrance_export);
        fwrite(ftw, exit_export);
        fclose(ftw);

        SendClientMessage(playerid, 0xAFAFAFAF, "[ENTRANCES] {E0E0E0}You successfully created new entrance with exit!");
        SendClientMessage(playerid, 0xAFAFAFAF, "[ENTRANCES] {E0E0E0}Please, inform {cf1f1f}Developer {E0E0E0}about creating new entrance!");

        last_entrance ++;
    }
    else
    {
        SendClientMessage(playerid, 0xAFAFAFAF, "[ENTRANCES] {E0E0E0}According to our system, there is no file containg entrance data!");
        SendClientMessage(playerid, 0xAFAFAFAF, "[ENTRANCES] {E0E0E0}You cannot create new entrance without writing data to file!"); 
    }

    entrance_name[0] = EOS;
    entrance_export[0] = EOS;
    exit_export[0] = EOS;
    return 1;
}