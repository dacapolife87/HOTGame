class HOTTemple Extends HOTActor
        placeable;

var int Health;

event TakeDamage(int DamageAmount,Controller EventInstigator,vector HitLocation,vector Momentum, class<DamageType> DamageType,Optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
     if(EventInstigator != none && EventInstigator.PlayerReplicationInfo != none)
        WorldInfo.Game.ScoreObjective(EventInstigator.PlayerReplicationInfo,0);

     Health -= DamageAmount;
     `log("Health" @Health);
     if(Health <=0)
     {
         Destroy();
         `log("health!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!= " @Health);
     }
}

event Bump(Actor Other,PrimitiveComponent OtherComp, vector HitNormal)
{
    `log("Bump!!!!!==============nexus");
    TakeDamage(HOTEnemy(other).BumpDamage,none,Location,vect(0,0,0),class'UTDmgType_LinkPlasma');

}

defaultproperties
{
    Health=200
    bBlockActors=True
    bCollideActors=True

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=True
    End Object
    Components.Add(MyLightEnvironment)

    Begin Object Class=StaticMeshComponent Name=TempleMesh
        StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
        Materials(0)=Material'EditorMaterials.WidgetMaterial_Y'
        LightEnvironment=MyLightEnvironment
        Scale3D=(X=0.25,Y=0.25,Z=0.5)
    End Object
    Components.Add(TempleMesh)

    Begin Object Class=CylinderComponent Name=CollisionCylinder
    CollisionRadius=32.0
    CollisionHeight=64.0
    BlockNonZeroExtent=true
    BlockZeroExtent=true
    BlockActors=true
    End Object
    CollisionComponent=CollisionCylinder
    Components.Add(MyLightEnvironment)
}