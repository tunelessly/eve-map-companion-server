package me.besunta.eveMapCompanion.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

@Configuration
@Profile("dev")
@EnableWebSecurity
public class SecurityConfigurationDev {
	private static final Logger logger = LoggerFactory.getLogger(SecurityConfigurationDev.class);

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        logger.warn("Dev security loaded");
        return http.build();
    }
}
