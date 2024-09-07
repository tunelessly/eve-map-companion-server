package me.besunta.eveMapCompanion;

import org.slf4j.LoggerFactory;

import java.util.Map;

import org.slf4j.Logger;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class EveMapCompanionApplication {

	private static final Logger logger = LoggerFactory.getLogger(EveMapCompanionApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(EveMapCompanionApplication.class, args);
	}

	@GetMapping("/hello")
	public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
		return String.format("Hello %s!", name);
	}

	@GetMapping("/ssi-callback")
	public String ssi_callback(@RequestParam Map<String, String> params) {
		logger.info(params.toString());
		return String.format("Hello %s!", params.toString());
	}

}
