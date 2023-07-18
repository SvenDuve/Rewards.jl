module Rewards

using RLTypes

export Reward, shaping



"""
    Reward

Reward struct for the environments. It contains the environment, the previous shaping, the game_over flag and the awake flag.
"""
mutable struct Reward
    environment::Environments
    #Both
    prev_shaping
    game_over
    # Bipedal Walker
    hullPosition
    # LunarLunar
    awake
    # Pendulum
    # Nothing to add
end


"""
    Reward(Environment::LunarLanderContinuous; prev_shaping = 0.f0, game_over = false, awake = true)

Constructor for the Reward struct for the LunarLanderContinuous environment.
"""
function Reward(Environment::LunarLanderContinuous; prev_shaping = 0.f0, game_over = false, awake = true)
    Reward(Environment, prev_shaping, game_over, nothing, awake)
end

"""
    Reward(Environment::LunarLanderDiscrete; prev_shaping = 0.f0, game_over = false, awake = true)

Constructor for the Reward struct for the LunarLanderDiscrete environment.
"""
function Reward(Environment::LunarLanderDiscrete; prev_shaping = 0.f0, game_over = false, awake = true)
    Reward(Environment, prev_shaping, game_over, nothing, awake)
end

"""
    Reward(Environment::Pendulum)

Constructor for the Reward struct for the Pendulum environment.
"""
function Reward(Environment::Pendulum)
    Reward(Environment, nothing, nothing, nothing, nothing)
end

"""
    Reward(Environment::Acrobot)

Constructor for the Reward struct for the Acrobot environment.
"""
function Reward(Environment::Acrobot)
    Reward(Environment, nothing, nothing, nothing, nothing)
end


"""
    (rew::Reward)(Environment::Pendulum, state, action, next_state)

Reward functor for the Pendulum environment.
"""
function (rew::Reward)(Environment::Pendulum, state, action, next_state)
    theta = atan(state[2], state[1])
    theta_dt = state[3]
    torque = action[1]
    return -(theta^2 + 0.1 * theta_dt^2 + 0.001 * torque^2)
    
end

"""
    (rew::Reward)(Environment::Acrobot, state, action, next_state)

Reward functor for the Acrobot environment.
"""
function (rew::Reward)(Environment::Acrobot, state, action, next_state)

    terminated = -next_state[1] - (next_state[1] * next_state[3] - next_state[2] * next_state[4]) > 1.0
    terminated ? reward = 0.f0 : reward = -1.f0 

    return reward
end

"""
    shaping(Environment::Pendulum, s)

Shaping function for the Pendulum environment.
"""
function shaping(Environment::Pendulum, s) end

"""
    shaping(Environment::Acrobot, s)

Shaping function for the Acrobot environment.
"""
function shaping(Environment::Acrobot, s) end

"""
    shaping(Environment::LunarLanderContinuous, s)

Shaping function for the LunarLanderContinuous environment.
"""
function shaping(Environment::LunarLanderContinuous, s)
    shape = -100 * sqrt(s[1] * s[1] + s[2] * s[2]) - 100 * sqrt(s[3] * s[3] + s[4] * s[4]) - 100 * abs(s[5]) + 10 * s[7] + 10 * s[8]
    return shape
end

"""
    shaping(Environment::LunarLanderDiscrete, s)

Shaping function for the LunarLanderDiscrete environment.
"""
function shaping(Environment::LunarLanderDiscrete, s)
    shape = -100 * sqrt(s[1] * s[1] + s[2] * s[2]) - 100 * sqrt(s[3] * s[3] + s[4] * s[4]) - 100 * abs(s[5]) + 10 * s[7] + 10 * s[8]
    return shape
end

"""
    (rew::Reward)(Environment::LunarLanderContinuous, state, action, next_state)

Reward functor for the LunarLanderContinuous environment.
"""
function (rew::Reward)(Environment::LunarLanderContinuous, state, action, next_state)


    reward = 0
    shape = shaping(rew.environment, next_state) # And ten points for legs contact, the idea is if you
    # lose contact again after landing, you get negative reward
    if rew.prev_shaping != 0.0
        reward = shape - rew.prev_shaping
    end

    rew.prev_shaping = shape

    action[1] > 0.0 ? m_power = (clamp(action[1], 0.0, 1.0) + 1.0) * 0.5 : m_power = 0.0
    abs(action[2]) > 0.5 ? s_power = clamp(abs(action[2]), 0.5, 1.0) : s_power = 0.0

    reward -= (m_power * 0.30)  # less fuel spent is better, about -30 for heuristic landing
    reward -= (s_power * 0.03)

    next_state[9] >= 0.99 ? rew.game_over = true : rew.game_over = false
    next_state[10] >= 0.99 ? rew.awake = false : rew.awake = true

    if rew.game_over || abs(next_state[1]) >= 1.0
        reward = -100
    end
    if !rew.awake
        reward = 100
    end
    
    return reward#, terminated

    
end


"""
    (rew::Reward)(Environment::LunarLanderDiscrete, state, action, next_state)

Reward functor for the LunarLanderDiscrete environment.
""" 
function (rew::Reward)(Environment::LunarLanderDiscrete, state, action, next_state)


    reward = 0
    shape = shaping(rew.environment, next_state) # And ten points for legs contact, the idea is if you
    # lose contact again after landing, you get negative reward
    if rew.prev_shaping != 0.0
        reward = shape - rew.prev_shaping
    end

    rew.prev_shaping = shape

    action[1] == 2 ? m_power = 1.0 : m_power = 0.0
    action[1] ∈ [1, 3] ? s_power = 1.0 : s_power = 0.0

    reward -= (m_power * 0.30)  # less fuel spent is better, about -30 for heuristic landing
    reward -= (s_power * 0.03)

    next_state[9] >= 0.99 ? rew.game_over = true : rew.game_over = false
    next_state[10] >= 0.99 ? rew.awake = false : rew.awake = true

    if rew.game_over || abs(next_state[1]) >= 1.0
        reward = -100
    end
    if !rew.awake
        reward = 100
    end
    
    return reward#, terminated

    
end


end # module Rewards
