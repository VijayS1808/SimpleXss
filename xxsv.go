package main

import (
	"fmt"
	"os/exec"
	"strings"
)

func main() {
	// Use subfinder to find subdomains with specific options
	subfinder := exec.Command("subfinder", "-d example.com", "-t 100", "-d 500ms", "-b", "Mozilla/5.0")
	subfinderOut, _ := subfinder.Output()
	fmt.Printf("%s\n", subfinderOut)

	// Use gau to scrape information from the subdomains with specific options
	gau := exec.Command("gau", "example.com", "-hidden")
	gauOut, _ := gau.Output()
	fmt.Printf("%s\n", gauOut)

	// Use kxss to check for XSS vulnerabilities with specific options
	kxss := exec.Command("kxss", "example.com", "-threads", "100", "-timeout", "5s", "-silent")
	kxss.Stdin = strings.NewReader(string(gauOut))
	kxssOut, _ := kxss.Output()
	fmt.Printf("%s\n", kxssOut)

	// Use uniq to remove duplicate output
	uniq := exec.Command("uniq")
	uniq.Stdin = strings.NewReader(string(kxssOut))
	uniqOut, _ := uniq.Output()
	fmt.Printf("%s\n", uniqOut)
}
