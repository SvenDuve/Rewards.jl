using Rewards
using RLTypes
using Test

@testset "Rewards.jl" begin
    # Write your tests here.
    rew = Reward(Pendulum())
    @test rew(Pendulum(), [0, 0, 0], [0], [0, 0, 0]) == 0
end
