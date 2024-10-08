---@diagnostic disable
return function(mode)
    local entities = {{Name="Snidge",Anm2="monsters/snidge/snidge.anm2",HP="0.1",Champion="",CollisionDamage=1,CollisionMass=3,CollisionRadius=17,ShadowSize=11,NumGridCollisionPoints=4,Type=161,Variant=6,Tags="fly",GridCollision="walls",Portrait=6,},
    {Name="Floater",Anm2="monsters/floater/floater.anm2",HP=10,StageHP=3,Champion=true,CollisionDamage=1,CollisionMass=5,CollisionRadius=13,ShadowSize=16,NumGridCollisionPoints=12,Type=161,Variant=11,HasFloorAlts="true",Portrait=11,},
    {Name="Fivehead",Anm2="monsters/fivehead/fivehead.anm2",HP=15,Champion=true,CollisionDamage=1,CollisionMass=40,CollisionRadius=13,Friction="0.1",ShadowSize=14,NumGridCollisionPoints=12,Type=161,Variant=12,HasFloorAlts="true",Portrait=12,},
    {Name="Neutral Fly",Anm2="monsters/neutralfly/neutralfly.anm2",HP=10,Champion=true,CollisionDamage=1,CollisionMass=6,CollisionRadius=13,ShadowSize=14,NumGridCollisionPoints=8,Type=161,Variant=20,Tags="fly",GridCollision="walls",Portrait=20,},
    {Name="Dried",Anm2="monsters/dried/dried.anm2",HP=20,CollisionDamage=1,CollisionMass=40,CollisionRadius=10,ShadowSize=20,NumGridCollisionPoints=12,Type=161,Variant=40,ShutDoors="false",Portrait=40,},
    {Name="Dried (Black)",Anm2="monsters/dried/dried.anm2",HP=20,CollisionDamage=1,CollisionMass=40,CollisionRadius=10,ShadowSize=20,NumGridCollisionPoints=12,Type=161,Variant=40,Subtype=1,ShutDoors="false",Portrait=40,},
    {Name="Dried (White)",Anm2="monsters/dried/dried.anm2",HP=20,CollisionDamage=1,CollisionMass=40,CollisionRadius=10,ShadowSize=20,NumGridCollisionPoints=12,Type=161,Variant=40,Subtype=2,ShutDoors="false",},
    {Name="Dried (Brown)",Anm2="monsters/dried/dried.anm2",HP=20,CollisionDamage=1,CollisionMass=40,CollisionRadius=10,ShadowSize=20,NumGridCollisionPoints=12,Type=161,Variant=40,Subtype=3,ShutDoors="false",},
    {Name="Dried (Green)",Anm2="monsters/dried/dried.anm2",HP=20,CollisionDamage=1,CollisionMass=40,CollisionRadius=10,ShadowSize=20,NumGridCollisionPoints=12,Type=161,Variant=40,Subtype=4,ShutDoors="false",},
    {Name="Dried (Yellow)",Anm2="monsters/dried/dried.anm2",HP=20,CollisionDamage=1,CollisionMass=40,CollisionRadius=10,ShadowSize=20,NumGridCollisionPoints=12,Type=161,Variant=40,Subtype=5,ShutDoors="false",},
    {Name="Dried (Red)",Anm2="monsters/dried/dried.anm2",HP=20,CollisionDamage=1,CollisionMass=40,CollisionRadius=10,ShadowSize=20,NumGridCollisionPoints=12,Type=161,Variant=40,Subtype=6,ShutDoors="false",},
    {Name="Schmoot",Anm2="monsters/schmoot/shmoot.anm2",HP=15,Champion=true,CollisionDamage=1,CollisionMass=3,CollisionRadius=13,ShadowSize=13,NumGridCollisionPoints=12,Type=161,Variant=90,Portrait=90,},
    {Name="Wost",Anm2="monsters/wost/wost.anm2",HP=15,StageHP=1,CollisionDamage=1,CollisionMass=40,CollisionRadius=13,ShadowSize=5,NumGridCollisionPoints=5,Type=161,Variant=118,Portrait=118,},
    {Name="Drosslet",Anm2="monsters/drosslet/drosslet.anm2",HP=10,StageHP=1,CollisionDamage=1,CollisionMass=40,CollisionRadius=13,Friction="0.8",ShadowSize=5,NumGridCollisionPoints=5,Type=161,Variant=177,Portrait=177,},
    {Name="A gaper w/ three legs, why did we do this",Anm2="jokes/enemies/gaperrr/gaperrr.anm2",HP=13,StageHP=3,Champion=true,CollisionDamage=1,CollisionMass=40,CollisionRadius=13,ShadowSize=12,NumGridCollisionPoints=12,Type=10,Variant=5938,},}
    if not mode or mode == 1 then
        return entities
    elseif mode == 2 then
        return {["Snidge"]=entities[1],["Floater"]=entities[2],["Fivehead"]=entities[3],["Neutral Fly"]=entities[4],["Dried"]=entities[5],["Dried (Black)"]=entities[6],["Dried (White)"]=entities[7],["Dried (Brown)"]=entities[8],["Dried (Green)"]=entities[9],["Dried (Yellow)"]=entities[10],["Dried (Red)"]=entities[11],["Schmoot"]=entities[12],["Wost"]=entities[13],["Drosslet"]=entities[14],["A gaper w/ three legs, why did we do this"]=entities[15],}
    elseif mode == 3 then
        return {[161]={[6]={[0]=entities[1],},[11]={[0]=entities[2],},[12]={[0]=entities[3],},[20]={[0]=entities[4],},[40]={[0]=entities[5],[1]=entities[6],[2]=entities[7],[3]=entities[8],[4]=entities[9],[5]=entities[10],[6]=entities[11],},[90]={[0]=entities[12],},[118]={[0]=entities[13],},[177]={[0]=entities[14],},},[10]={[5938]={[0]=entities[15],},},}
    end    
end