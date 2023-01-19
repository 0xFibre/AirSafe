<template>
  <v-table>
    <tbody>
      <template v-for="(transaction, i) in transactions" :key="i">
        <tr>
          <td>
            <v-icon
              v-if="[0, 1].includes(transaction.type)"
              icon="mdi-arrow-top-right"
              color="error"
            />

            <v-icon
              v-else-if="transaction.type == 2"
              icon="mdi-account-plus"
              color="success"
            />

            <v-icon
              v-else-if="transaction.type == 3"
              icon="mdi-account-minus"
              color="error"
            />

            <v-icon
              v-else-if="transaction.type == 4"
              icon="mdi-cog"
              color="grey"
            />
          </td>

          <td>
            <div class="mb-2 mb-sm-0">
              {{ transaction.typeValue }}
            </div>
          </td>

          <td>
            <div v-if="transaction.type == 0" class="d-flex align-center">
              <v-avatar size="20" class="me-2">
                <v-img :src="transaction.coin?.metadata.iconUrl" />
              </v-avatar>

              <div>
                {{
                  utils.formatBalance(
                    transaction.input.amount,
                    transaction.coin?.metadata.decimals!
                  )
                }}
                {{ transaction.coin?.metadata.symbol }}
              </div>
            </div>

            <div v-else-if="transaction.type == 1" class="d-flex align-center">
              {{ transaction.input.assetType }}
            </div>

            <div
              v-else-if="[2, 3].includes(transaction.type)"
              class="d-flex align-center"
            >
              {{ utils.truncate0x(`0x${transaction.input.owner}`, 6) }}
            </div>
          </td>

          <td>
            <div class="mb-2 mb-sm-0 text-center">
              <v-chip
                label
                density="comfortable"
                :color="
                  transaction.status == 0
                    ? 'primary'
                    : transaction.status == 1
                    ? 'info'
                    : transaction.status == 2
                    ? 'error'
                    : transaction.status == 3
                    ? 'success'
                    : ''
                "
              >
                {{ transaction.statusValue }}
              </v-chip>
            </div>
          </td>

          <td class="text-right">
            <div class="mb-2 mb-sm-0 align-self-end">
              <v-btn
                flat
                variant="text"
                color="primary"
                density="compact"
                append-icon="mdi-arrow-right"
                :to="`/transaction/${transaction.id}`"
              >
                open
              </v-btn>
            </div>
          </td>
        </tr>
      </template>
    </tbody>
  </v-table>
</template>

<script lang="ts" setup>
import { SafeTransaction } from "@/lib/entity";
import { utils } from "@/utils";

defineProps<{ transactions: SafeTransaction[] }>();
</script>
