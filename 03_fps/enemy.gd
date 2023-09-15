extends CharacterBody3D


func take_damage():
    $AnimationPlayer.play("death")
