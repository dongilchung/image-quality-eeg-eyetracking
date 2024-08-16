evTab <- evTab_4_all_tasks

# Define categorical variables
evTab$sub <- factor(evTab$sub)
evTab$task <- factor(evTab$task)
evTab$white_boost <- factor(evTab$white_boost)


# ANCOVA with repeated measure design and 2 covariates
fit <- aov(MeanPupDiam ~ white_boost*task*valence*arousal + Error(sub/(white_boost*task*valence*arousal)), data = evTab)
summary(fit)
sum <- summary(fit)



# Extract results
# main effect of white boost
df <- sum$`Error: sub:white_boost`[[1]]$Df
F_val <- sum$`Error: sub:white_boost`[[1]]$`F value`[1]
p_val <- sum$`Error: sub:white_boost`[[1]]$`Pr(>F)`[1]

# main effect of valence (covariate)
coeff <- fit$`sub:valence`$coefficients[1]
p_val <- sum$`Error: sub:valence`[[1]]$`Pr(>F)`[1]

# interaction effect between white boost & task
df <- sum$`Error: sub:white_boost:task`[[1]]$Df
F_val <- sum$`Error: sub:white_boost:task`[[1]]$`F value`[1]
p_val <- sum$`Error: sub:white_boost:task`[[1]]$`Pr(>F)`[1]

# interaction effect between white boost & valence (covariate)
df <- sum$`Error: sub:white_boost:valence`[[1]]$Df
coeff <- fit$`sub:white_boost:valence`$coefficients[1:2] # not sure how interpret this
F_val <- sum$`Error: sub:white_boost:valence`[[1]]$`F value`[1]
p_val <- sum$`Error: sub:white_boost:valence`[[1]]$`Pr(>F)`[1]


# Posthoc test
# install 'TukeyC' package
tk <- with(evTab, TukeyC(fit, which='white_boost'))
summary(tk)

tk <- with(evTab, TukeyC(fit, which='white_boost:task', fl1=1))
summary(tk)
