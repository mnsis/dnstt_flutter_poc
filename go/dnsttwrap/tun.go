package dnsttwrap

import (
	"context"
	"sync"

	"example.com/dnsttwrap/dnsttlib"
)

var (
	mu      sync.Mutex
	running bool
	lastErr string
	cancel  context.CancelFunc
)

// StartTunnel starts the stub tunnel runner.
func StartTunnel(domain, pubkey, resolver string) bool {
	mu.Lock()
	defer mu.Unlock()
	if running {
		lastErr = "tunnel already running"
		return false
	}

	ctx, cancelFn := context.WithCancel(context.Background())
	cancel = cancelFn
	running = true
	lastErr = ""

	go func() {
		err := dnsttlib.Run(ctx, domain, pubkey, resolver)
		mu.Lock()
		defer mu.Unlock()
		if err != nil && err != context.Canceled {
			lastErr = err.Error()
		}
		running = false
	}()

	return true
}

// StopTunnel stops the stub tunnel runner.
func StopTunnel() {
	mu.Lock()
	defer mu.Unlock()
	if cancel != nil {
		cancel()
		cancel = nil
	}
	running = false
}

// IsRunning reports whether the stub tunnel is running.
func IsRunning() bool {
	mu.Lock()
	defer mu.Unlock()
	return running
}

// LastError returns the last recorded error string.
func LastError() string {
	mu.Lock()
	defer mu.Unlock()
	return lastErr
}
