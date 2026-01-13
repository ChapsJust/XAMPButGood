package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/ChapsJust/XAMPButGood/cli/templates"
	"github.com/spf13/cobra"
)

// For build "go build -o ~/go/bin/devstack.exe"
func main() {
	rootCmd := &cobra.Command{
		Use:   "devstack",
		Short: "A simple Docker dev environment manager",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("devstack v0.1.0 - Use 'devstack --help' for commands")
		},
	}

	// devstack init [services...]
	initCmd := &cobra.Command{
		Use:   "init [services...]",
		Short: "Initialize a new devstack project",
		Example: "devstack init postgres redis",
		Run: func(cmd *cobra.Command, args []string) {
			initProject(args)
		},
	}

	// devstack add [services...]
	addCmd := &cobra.Command{
		Use:   "add [services...]",
		Short: "Add services to existing project",
		Example: "devstack add mysql mongodb",
		Run: func(cmd *cobra.Command, args []string) {
			addServices(args)
		},
	}

	// devstack list
	listCmd := &cobra.Command{
		Use:   "list",
		Short: "List available services",
		Run: func(cmd *cobra.Command, args []string) {
			listServices()
		},
	}

	// devstack up
	upCmd := &cobra.Command{
		Use:   "up",
		Short: "Start all services",
		Run: func(cmd *cobra.Command, args []string) {
			runDocker("up", "-d")
		},
	}

	// devstack down
	downCmd := &cobra.Command{
		Use:   "down",
		Short: "Stop all services",
		Run: func(cmd *cobra.Command, args []string) {
			runDocker("down")
		},
	}

	// devstack ps
	psCmd := &cobra.Command{
		Use:   "ps",
		Short: "Show running services",
		Run: func(cmd *cobra.Command, args []string) {
			runDocker("ps")
		},
	}

	rootCmd.AddCommand(initCmd, addCmd, listCmd, upCmd, downCmd, psCmd)

	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func listServices() {
	fmt.Println("Available services:")
	for name := range templates.ServiceDescriptions {
		fmt.Println("  -", name)
	}
}

func initProject(services []string) {
	// Check if docker-compose.yml already exists
	if _, err := os.Stat("docker-compose.yml"); err == nil {
		fmt.Println("docker-compose.yml already exists. Use 'devstack add' instead.")
		return
	}

	if len(services) == 0 {
		fmt.Println("No services specified")
		fmt.Println("Usage: devstack init postgres redis")
		fmt.Println("Run 'devstack list' to see available services")
		return
	}

	// Validate services
	for _, s := range services {
		if _, ok := templates.Services[s]; !ok {
			fmt.Printf("Unknown service: %s\n", s)
			fmt.Println("Run 'devstack list' to see available services")
			return
		}
	}

	// Build docker-compose.yml
	var servicesYaml strings.Builder
	var volumesYaml strings.Builder
	var envContent strings.Builder

	envContent.WriteString("# devstack environment\nCOMPOSE_PROJECT_NAME=devstack\n\n")

	for _, s := range services {
		servicesYaml.WriteString(templates.Services[s])
		servicesYaml.WriteString("\n")
		volumesYaml.WriteString(templates.Volumes[s])
		envContent.WriteString(templates.EnvVars[s])
		envContent.WriteString("\n")
	}

	compose := fmt.Sprintf("services:\n%s\nvolumes:\n%s", servicesYaml.String(), volumesYaml.String())

	os.WriteFile("docker-compose.yml", []byte(compose), 0644)
	os.WriteFile(".env", []byte(envContent.String()), 0644)

	fmt.Println("Created docker-compose.yml")
	fmt.Println("Created .env")
	fmt.Println("")
	fmt.Println("Services added:", strings.Join(services, ", "))
	fmt.Println("")
	fmt.Println("Next: devstack up")
}

func addServices(services []string) {
	// Check if docker-compose.yml exists
	if _, err := os.Stat("docker-compose.yml"); os.IsNotExist(err) {
		fmt.Println("No docker-compose.yml found. Run 'devstack init' first.")
		return
	}

	if len(services) == 0 {
		fmt.Println("No services specified")
		fmt.Println("Usage: devstack add mysql mongodb")
		return
	}

	// Read existing files
	composeBytes, _ := os.ReadFile("docker-compose.yml")
	envBytes, _ := os.ReadFile(".env")
	composeContent := string(composeBytes)
	envContent := string(envBytes)

	var added []string

	for _, s := range services {
		// Check if service exists in templates
		if _, ok := templates.Services[s]; !ok {
			fmt.Printf("Unknown service: %s\n", s)
			continue
		}

		// Check if already in docker-compose.yml
		if strings.Contains(composeContent, "container_name: dev-"+s) {
			fmt.Printf("Warning: %s already exists, skipping\n", s)
			continue
		}

		// Add service before "volumes:" line
		serviceYaml := templates.Services[s] + "\n"
		composeContent = strings.Replace(composeContent, "\nvolumes:\n", "\n"+serviceYaml+"volumes:\n", 1)

		// Add volume
		volumeYaml := templates.Volumes[s]
		composeContent = composeContent + volumeYaml

		// Add env vars
		envContent = envContent + templates.EnvVars[s] + "\n"

		added = append(added, s)
	}

	if len(added) > 0 {
		os.WriteFile("docker-compose.yml", []byte(composeContent), 0644)
		os.WriteFile(".env", []byte(envContent), 0644)
		fmt.Println("Added:", strings.Join(added, ", "))
	}
}

func runDocker(args ...string) {
	cmd := exec.Command("docker", append([]string{"compose"}, args...)...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		fmt.Println("Error:", err)
	}
}