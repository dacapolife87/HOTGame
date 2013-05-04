class HOTGame extends UTDeathmatch;

var int EnemiesLeft;
var array<HOTEnemySpawner> EnemySpawners;

var float MinSpawnerDistance, MaxSpawnerDistance;

simulated function PostBeginPlay()
{
    local HOTEnemySpawner ES;

    super.PostBeginPlay();

    GoalScore = EnemiesLeft;

    foreach DynamicActors(class'HOTEnemySpawner', ES)
        EnemySpawners[EnemySpawners.length] = ES;

    SetTimer(5.0, false, 'ActivateSpawners');
}

function ActivateSpawners()
{
    local int i;
    local array<HOTEnemySpawner> InRangeSpawners;
    local HOTPlayerController PC;

    foreach LocalPlayerControllers(class'HOTPlayerController', PC)
        break;
    if(PC.Pawn == none)
    {
        SetTimer(1.0, false, 'ActivateSpawners');
        return;
    }

    for(i=0; i<EnemySpawners.length; i++)
    {
        if(VSize(PC.Pawn.Location - EnemySpawners[i].Location) > MinSpawnerDistance && VSize(PC.Pawn.Location - EnemySpawners[i].Location) < MaxSpawnerDistance)
        {
            if(EnemySpawners[i].CanSpawnEnemy())
                InRangeSpawners[InRangeSpawners.length] = EnemySpawners[i];
        }
    }

    if(InRangeSpawners.length == 0)
    {
        `log("No enemy spawners within range!");
        SetTimer(1.0, false, 'ActivateSpawners');
        return;
    }

    InRangeSpawners[Rand(InRangeSpawners.length)].SpawnEnemy();

    SetTimer(1.0 + FRand() * 3.0, false, 'ActivateSpawners');
}

function ScoreObjective(PlayerReplicationInfo Scorer, Int Score)
{
    local int i;

    EnemiesLeft--;
    super.ScoreObjective(Scorer, Score);

    if(EnemiesLeft == 0)
    {
        for(i=0; i<EnemySpawners.length; i++)
            EnemySpawners[i].MakeEnemyRunAway();
        ClearTimer('ActivateSpawners');
    }
}

defaultproperties
{
    MinSpawnerDistance=1700.0
    MaxSpawnerDistance=3000.0
    EnemiesLeft=10
    bScoreDeaths=false
    PlayerControllerClass=class'HOTGame.HOTPlayerController'
    DefaultPawnClass=class'HOTGame.HOTPawn'
    DefaultInventory(0)=None
}
