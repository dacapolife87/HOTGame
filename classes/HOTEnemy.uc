class HOTEnemy extends HOTActor;

var float BumpDamage;
var Actor Enemy;
var float MovementSpeed;
var float AttackDistance;
var int Health;
function GetEnemy()
{

    local HOTTemple AT;

    foreach DynamicActors(class'HOTTemple',AT)
    if(AT != none){
            Enemy = AT;
    }
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if(EventInstigator != none && EventInstigator.PlayerReplicationInfo != none)
        WorldInfo.Game.ScoreObjective(EventInstigator.PlayerReplicationInfo, 1);

    if(HOTEnemySpawner(Owner) != none)
        HOTEnemySpawner(Owner).EnemyDied();


    Health -= DamageAmount;
    if(Health==0){
        Destroy();
    }
}

function RunAway()
{
    GoToState('Fleeing');
}

auto state Seeking
{
    function Tick(float DeltaTime)
    {
        local vector NewLocation;

        if(Enemy == none)
            GetEnemy();
    
        if(Enemy != none)
        {
            NewLocation = Location;
            NewLocation += normal(Enemy.Location - Location) * MovementSpeed * DeltaTime;
            SetLocation(NewLocation);
    
            if(VSize(NewLocation - Enemy.Location) < AttackDistance)
                GoToState('Attacking');
        }
    }
}

state Attacking
{
    function Tick(float DeltaTime)
    {
        if(Enemy == none)
            GetEnemy();
    
        if(Enemy != none)
        {
            Enemy.Bump(self, CollisionComponent, vect(0,0,0));
    
            if(VSize(Location - Enemy.Location) > AttackDistance)
                GoToState('Seeking');
        }
    }
}

state Fleeing
{
    function Tick(float DeltaTime)
    {
        local vector NewLocation;
    
        if(Enemy == none)
            GetEnemy();
    
        if(Enemy != none)
        {
            NewLocation = Location;
            NewLocation -= normal(Enemy.Location - Location) * MovementSpeed * DeltaTime;
            SetLocation(NewLocation);
        }
    }
}

defaultproperties
{
    Health=100
    BumpDamage=2.0
    MovementSpeed=100.0
    AttackDistance=96.0
    bBlockActors=True
    bCollideActors=True

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=TRUE
    End Object
    Components.Add(MyLightEnvironment)

    Begin Object Class=StaticMeshComponent Name=PickupMesh
        StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
        Materials(0)=Material'EditorMaterials.WidgetMaterial_X'
        LightEnvironment=MyLightEnvironment
        Scale3D=(X=0.25,Y=0.25,Z=0.5)
    End Object
    Components.Add(PickupMesh)

    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=32.0
        CollisionHeight=64.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
}
