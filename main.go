package main

import (
	"context"
	"google.golang.org/api/iterator"

	"cloud.google.com/go/spanner"
	spannerbench "github.com/cloudspannerecosystem/spanner-bench"
)

func main() {
	spannerbench.Benchmark(
		"projects/benchmark/instances/my-instance/databases/benchdb",
		BenchmarkSubquery,
		BenchmarkJoin,
	)
}

func BenchmarkSubquery(b *spannerbench.B) {
	b.N(10)
	b.RunReadOnly(func(tx *spanner.ReadOnlyTransaction) error {
		ctx := context.Background()
		it := tx.Query(ctx, spanner.NewStatement("select * from Customer where " +
			"CustomerID in (select CustomerID from Sales where SalesID = 10000)"))
		defer it.Stop()

		for {
			_, err := it.Next()
			if err == iterator.Done {
				break
			}
			return err
		}
		return nil
	})
}

func BenchmarkJoin(b *spannerbench.B) {
	b.N(10)
	b.RunReadOnly(func(tx *spanner.ReadOnlyTransaction) error {
		ctx := context.Background()
		it := tx.Query(ctx, spanner.NewStatement("select * from Customer left join Sales on Customer.CustomerID = " +
			"Sales.CustomerID where Sales.SalesID = 10000"))
		defer it.Stop()

		for {
			_, err := it.Next()
			if err == iterator.Done {
				break
			}
			return err
		}
		return nil
	})
}
