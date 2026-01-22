package dnsttlib

import "context"

// Run is a stub tunnel runner that blocks until the context is canceled.
func Run(ctx context.Context, domain, pubkey, resolver string) error {
	<-ctx.Done()
	return ctx.Err()
}
